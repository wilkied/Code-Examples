<!--
**	Author: Debra Wilkie  
**  Class: CS340 Intro to Databases
**  Date: November 29, 2016
**	Project Requirements: Create a database driven website using HTML, PHP and MySQL
**	This is the main page of the website with the PHP displaying the information stored in the MySQL database
-->


<?php
//Turn on error reporting
ini_set('display_errors', 'On');
//Connects to the database
$mysqli = new mysqli("oniddb.cws.oregonstate.edu","wilkied-db","nCHk7JgEYVvSsddo","wilkied-db");
if($mysqli->connect_errno){
	echo "Connection error " . $mysqli->connect_errno . " " . $mysqli->connect_error;
	}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>

<head>
  <link rel="stylesheet" href="styles.css">
</head>

<body>
<a name="top"></a>
<ul id='menu'>
				<li>
					<a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/operaDatabase.php">Home Page</a>
				</li>
				<li>
					<a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/searchDB.php">Search Database</a>
				</li>
				<li>
					<a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/addToDB.php">Database Additions</a>
				</li>
				<li>
					<a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/updateOpera.php">Opera Updates</a>
				</li>
				<li>
					<a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/deleteFromDB.php">Delete From Database</a>
				</li>						
</ul>
<div class= "jumbotron", style="background-color:#d0e4fe">
		<h1 class= "how-to-title", style= "font-size:60px" ><center>Opera Aria Database</h1></center>
		<h1><center>The Search for Arias Made Easy</h1></center>
		<br />
		<h3 style= "text-align:right">Debra Wilkie</h3>
		<br />
</div>
<br />
<div>
	<p><strong>Welcome to the Opera Aria Database.</strong></p>
	<p>This database is designed to help you search for arias and operas.  You can find information on different composers, operas, voice types, opera characters, 
	languages, opera scenes and of course arias.<br>Below is the list of current operas, composers, opera characters and arias stored in the database.</p>
	<p>For fun, you can also add yourself as a composer and then write an opera.  Don't worry if you make a mistake you can always update or delete your 
	additions.<br>Please don't change the real database information or you will not get accurate information!</p>
	<p><strong>Thank you for visiting.</strong></p>
	<br />
</div>	
<div>
<h2>Let The Search Begin! <a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/searchDB.php">Search Database</a></h2>
</div>
<div>
<h2 class= "new", style= "background-color:#eee">Become an Opera Composer or Create a New Opera! <a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/addToDB.php">Database Additions</a></h2>
</div>
<div>
<h2>Update Opera Information! <a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/updateOpera.php">Opera Updates</a> </h2>
</div>
<div>
<h2 class= "new", style= "background-color:#eee">Delete a Composer or an Opera! <a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/deleteFromDB.php">Delete From Database</a></h2>
</div>
<br />
<br />
<div>
	<h2>Current Opera List</h2>
	<table>
		<thead>
			<tr>
				<th>Opera</th>
				<th>Opera English Name</th>
				<th>Composer</th>
				<th>Librettist</th>
				<th>Year Composed</th>
				<th>Language</th>						
			</tr>
		</thead>
<br />
<?php
if(!($stmt = $mysqli->prepare("SELECT opera.operaName, opera.operaNameEnglish, composer.composerLastName, opera.librettist, opera.yearComposed, languages.langType FROM opera
INNER JOIN composer ON composer.id = opera.composerID
INNER JOIN languages ON languages.id = opera.languagesID"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($opera, $operaNameEnglish, $composer, $librettist, $year_composed, $language)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
 echo "<tr>\n<td>\n" . $opera . "\n</td>\n<td>\n" . $operaNameEnglish . "\n</td>\n<td>\n" . $composer . "\n</td>\n<td>\n" . $librettist . "\n</td>\n<td>\n" . $year_composed . "\n</td>\n<td>\n" . $language . "\n</td>\n</tr>";
}
$stmt->close();
?>
	</table>
</div>
<br />
<div>
	<h2>Current Composer List</h2>
	<table>
		<thead>
			<tr>
				<th>Composer First Name</th>
				<th>Composer Last Name</th>
				<th>Birth Year</th>
				<th>Year of Death</th>
				<th>Country Name</th>		
			</tr>
		</thead>
<br />
<?php
if(!($stmt = $mysqli->prepare("SELECT composer.composerFirstName, composer.composerLastName, composer.birthYear, composer.yearOfDeath, composer.countryName FROM composer"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($composerFN, $composerLN, $birthYear, $yearOfDeath, $country)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
 echo "<tr>\n<td>\n" . $composerFN . "\n</td>\n<td>\n" . $composerLN . "\n</td>\n<td>\n" . $birthYear . "\n</td>\n<td>\n" . $yearOfDeath . "\n</td>\n<td>\n" . $country . "\n</td>\n</tr>";
}
$stmt->close();
?>
	</table>
</div>
<br />
<a href="#top">Back to top of page</a>
<div>
	<h2>Current Opera Characters</h2>
	<table>
		<thead>
			<tr>
				<th>Opera</th>
				<th>Character Name</th>
				<th>Voice Type</th>
			</tr>
		</thead>
<br />
<?php
if(!($stmt = $mysqli->prepare("SELECT opera.operaName, characterName.charName, voiceType.voiceTypeName FROM operaCharacter
INNER JOIN opera ON opera.id = operaCharacter.operaID
INNER JOIN characterName ON characterName.id = operaCharacter.characterNameID
INNER JOIN voiceType ON voiceType.id = operaCharacter.voiceTypeID"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($operaName, $charName, $vtname)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
 echo "<tr>\n<td>\n" . $operaName . "\n</td>\n<td>\n" . $charName . "\n</td>\n<td>\n" . $vtname . "\n</td>\n</tr>";
}
$stmt->close();
?>
	</table>
</div>
<br />
<a href="#top">Back to top of page</a>
<div>
	<h2>Current Opera Arias</h2>
	<table>
		<thead>
			<tr>
				<th>Aria</th>
				<th>Aria English Title</th>
				<th>Character Name</th>
				<th>Opera Act</th>
				<th>Opera Scene</th>
			</tr>
		</thead>
<br />
<?php
if(!($stmt = $mysqli->prepare("SELECT aria.ariaTitle, aria.ariaTitleEnglish, characterName.charName, operaScene.act, operaScene.scene FROM aria
INNER JOIN operaScene ON operaScene.id = aria.operaSceneID
INNER JOIN operaCharacter ON operaCharacter.id = aria.operaCharacterID
INNER JOIN characterName ON characterName.id = operaCharacter.characterNameID"))){
	echo "Prepare failed: "  . $stmt->errno . " " . $stmt->error;
}

if(!$stmt->execute()){
	echo "Execute failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
if(!$stmt->bind_result($ariaTitle, $ariaTitleEnglish, $charName, $act, $scene)){
	echo "Bind failed: "  . $mysqli->connect_errno . " " . $mysqli->connect_error;
}
while($stmt->fetch()){
 echo "<tr>\n<td>\n" . $ariaTitle . "\n</td>\n<td>\n" . $ariaTitleEnglish . "\n</td>\n<td>\n" . $charName . "\n</td>\n<td>\n" . $act . "\n</td>\n<td>\n" . $scene . "\n</td>\n</tr>";
}
$stmt->close();
?>
	</table>
</div>
<br />
<a href="#top">Back to top of page</a>
<br />
<br />
<div>
	<form>
      <fieldset>
       <legend><strong>Website Pages</strong></legend>
			<ul>
				<li>
					<code><a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/operaDatabase.php">Home Page</a></code>
				</li>
				<li>
					<code><a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/searchDB.php">Search Database</a></code>
				</li>
				<li>
					<code><a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/addToDB.php">Database Additions</a></code>
				</li>
				<li>
					<code><a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/updateOpera.php">Opera Updates</a></code>
				</li>
				<li>
					<code><a href="http://web.engr.oregonstate.edu/~wilkied/CS340/OperaDB/deleteFromDB.php">Delete From Database</a></code>
				</li>						
			</ul>
      </fieldset>	  
	</form>
</div>
<br />
<br />
<br />
</body>
</html>
