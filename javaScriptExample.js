/*
** Author: Debra Wilkie
** Group Project: Build a Heroku website and PostgresSQL database to create Employee Recognition Awards
** This is the create-award javascript file utilizing node.js, handlebars, express, and nodeMailer
** Users input the name, date, award type, the program updates the tex file and creates and emails a PDF
** Mustache is used to replace key words in a prepared tex file with user inputs 
** Child process is required for the creation of the PDF, and nodeMailer is used as the demo PDF email
*/

const express = require('express');
const router = express.Router();
const { Client } = require('pg');
var path = require("path");
var mu = require("mu2");
var fs = require("fs-extra");
const db = require('../db');
const nodemailer = require('nodemailer');
var spawn = require("child_process").spawnSync;

router.get('/', (req, res) => {
	res.render('create-awards');
});

router.post('/', (req, res) => {

	//Create-award user inputs
	var awardType = req.body.award_type;
	var winFirst = req.body.winnerFirstName;
	var winLast = req.body.winnerLastName;
	var winEmail = req.body.winnerEmail;
	var date = req.body.dateCreated;
	var creatorFirst;
	var creatorLast;
	var employee_id;

	//path to the images folder on Heroku
	var string = "";
	var latexFolder = "/app/public/images/";
	console.log('before first query');
	
	//querying the database to pull user information for latex creation
	db.query('SELECT * FROM employee WHERE employee_email = $1',[req.session.username], (err, results) => {
		//console.log(req.session.username);
		if(results.rowCount === 0) {
			res.status(404).send("User Does Not Exist");
		}
		else {

			employee_id = results.rows[0].employee_id;
			creatorFirst =  results.rows[0].employee_first_name;
			creatorLast = results.rows[0].employee_last_name;
		}

		//console.log("before second query");
		//inserting award into database
		db.query("INSERT into award (award_name, creator, recipient, award_created,employee_id, recipient_first) VALUES($1, $2, $3, $4, $5, $6)", [awardType, creatorLast, winLast, 'now', employee_id, winFirst],(err, results) => {
			if (err) {
				return console.error('error running query', err);
			}
			else {
				
				//mu2 is used to replace the key words with the user inputs {{ award_type }}
				//Pulls from the root tex file in the images folder and compiles and renders the changes
				mu.root = latexFolder;
				mu.compileAndRender("certTex.tex", {"award_type": awardType, "winnerFirstName": winFirst, "winnerLastName": winLast, "date": date, "creatorFirstName": creatorFirst, "creatorLastName": creatorLast})
				//Data is set to a string
				.on("data", function (data) {
					string = string + data.toString();
				})
				.on("end", function () {

					//Creates a unique file name for each newly created tex document
					var fileName = (winLast + date + ".tex");
					var file = latexFolder + "/" + winLast + date + ".tex";
					console.log("full file name = " + file);

					//Create the rendered file and compile
					'use strict';
					//console.log(string);
					fs.writeFileSync(file, string); //, function (err) {
						// if (err) {
						// 	throw 'error writing file: ' + err;
						// } else {
							//Testing
							if(fs.existsSync(file)) {
								console.log("FILE EXISTS RIGHT NOW");
							} else {
								console.log("File not exist :(");
							}
							console.log(file);

							//Creates the pdf from the tex document with latexmk found within the texLive buildpack
							//Child process is necessary since latexmk requires several passes to complete
							var pdfLatex = spawn("latexmk", ["-outdir=" + latexFolder, "-pdf", file], {stdio: 'inherit'});
							// pdfLatex.stdout.on("end", function (data) {
								var pdfFileName = winLast + date + '.pdf';

								// Generate SMTP service account from ethereal.email to send PDF
								console.log('before test accounts');
								
								nodemailer.createTestAccount((err, account) => {
									if (err) {
										console.error('Failed to create a testing account');
										console.error(err);
										return process.exit(1);
									}

									// Create a SMTP transporter object
									let transporter = nodemailer.createTransport({
										host: account.smtp.host,
										port: account.smtp.port,
										secure: account.smtp.secure,
										auth: {
											user: account.user,
											pass: account.pass
										},
										logger: false,
										debug: false // include SMTP traffic in the logs
									});

									//Testing
									console.log("before message");

									if(fs.existsSync(file)) {
										console.log("TEX FILE EXISTS");
									} else {
										console.log("File not exist :(");
									}

									if(fs.existsSync(latexFolder + "/" + pdfFileName)){
										console.log("PDF FILE EXISTS");
									} else {
										console.log("PDF FILE NOT EXIST");
									}
									
									// Message object
									let message = {
										from: 'CraterInc <no-reply@craterInc.com>',  //sender info
										to: winFirst + ' ' + winLast + '<' + winEmail + '>', //Comma separated list of recipients: 'Russel Metzger<rmetzger@craterinc.com>',
										subject: 'Certificate ✔',
										text: 'Congratulations!',  //plaintext
										html: '<p><b>Congratulations</b></p>' +  //HTML body with 2 lines
										'<p>Crater Incorporated, would like to extend our appreciation for the amazing work you have accomplished.  Your diligence, self-motivation as well as dedication have been a source of inspiration for the rest of the team.<br/><br/> Thank you for all your effort.<br/><br/>Best regards,<br/>The Crater Inc Management Team</p>',
										attachments: [   // An array of attachments
											// File Stream attachment
											{
												filename:  pdfFileName,    //'latexCertEx2.pdf',
												path: latexFolder + "/" + pdfFileName,
												cid: 'nyan34@example.com' // should be as unique as possible
											}
										]
									};
							
								try{
									console.log("sending mail");
									transporter.sendMail(message, (error, info) => {
										if (error) {
											console.log('Error occurred');
											console.log(error.message);
											 return process.exit(1);
										}

										console.log('Message sent successfully!');
										console.log(nodemailer.getTestMessageUrl(info));
										var url = nodemailer.getTestMessageUrl(info);
										res.render('send-award', {message: " " + url, succesful_message: "Your Award Profile has been Sent Successfully!" });
									});
								} catch(e) {
									console.log("ERROR: " + e);
									res.status(500).send();
								}
								});

				}).on("error", function(err) {
					console.log("error with mu");
					res.status(500).send();
				});
			}
		});
	});

});

module.exports = router;
