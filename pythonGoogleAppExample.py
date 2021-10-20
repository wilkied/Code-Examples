#
# Author: Debra Wilkie
# Project: Create an API utilizing Google Platform WebApp2 to organize boats and slips
# Boats and slips can be created, modified and deleted
# Boats are assigned a slip or at sea, reassigning a boat or slip updates the status via a single API call
#

from google.appengine.ext import ndb
import webapp2
import json
	
class Boat(ndb.Model):
	name = ndb.StringProperty(required=True)
	type = ndb.StringProperty(required=True)
	length = ndb.IntegerProperty(required=True) 
	at_sea = ndb.StringProperty(default= 'true')
	
class Slip(ndb.Model):
	number = ndb.IntegerProperty(required=True) 
	current_boat = ndb.StringProperty(default='empty')
	arrival_date = ndb.StringProperty()
	departure_history = ndb.StringProperty()
	
class BoatHandler(webapp2.RequestHandler): #Create a boat
	def post(self):
		boat_data = json.loads(self.request.body) 
		new_boat = Boat(name=boat_data['name'], type=boat_data['type'], length=boat_data['length'])
		new_boat.put()
		boat_dict = new_boat.to_dict()
		boat_dict['self'] = '/boat/' + new_boat.key.urlsafe() 
		boat_dict['id'] = new_boat.key.id()
		self.response.write(json.dumps(boat_dict))
		
	def get(self, id=None): 
		if id: 
			b = ndb.Key(urlsafe=id).get() 
			b_d = b.to_dict() 
			b_d['self'] = "/boat/" + id
			self.response.write(json.dumps(b_d)) 
			
class SlipHandler(webapp2.RequestHandler): #Create a slip
	def post(self):
		slip_data = json.loads(self.request.body)
		new_slip = Slip(number=slip_data['number'])
		new_slip.put()
		slip_dict = new_slip.to_dict()
		slip_dict['self'] = '/slip/' + new_slip.key.urlsafe() 
		slip_dict['id'] = new_slip.key.id()
		self.response.write(json.dumps(slip_dict))
		
	def get(self, id=None): 
		if id: 
			s = ndb.Key(urlsafe=id).get() 
			s_d = s.to_dict() 
			s_d['self'] = "/slip/" + id
			self.response.write(json.dumps(s_d))

class BoatListHandler(webapp2.RequestHandler): #view all boats
	def get(self, id=None): #View boat list
		boats = Boat.query()
		for boat in boats:
			key = boat.key.urlsafe()
			self.response.write(boat)
			self.response.write(key)
			space = " \n"  #creates a space in the output
			self.response.write(str(space))

class SlipListHandler(webapp2.RequestHandler): #view all slips
	def get(self, id=None): #View slip list
		slips = Slip.query()
		for slip in slips:
			key = slip.key.urlsafe()
			self.response.write(slip)
			self.response.write(key)
			space = " \n"  #creates a space in the output
			self.response.write(str(space))

class SlipDepartHandler(webapp2.RequestHandler): #view departure history
	def get(self, id=None): #View slip list
		s = ndb.Key(urlsafe=id).get() 
		s_d = s.to_dict() 
		hist = s_d['departure_history']
		self.response.write(json.dumps(hist)) 			
				
class BoatModifyHandler(webapp2.RequestHandler): #list, delete, modify boat
	def get(self, id=None): #View single boat
			b = ndb.Key(urlsafe=id).get() 
			b_d = b.to_dict() 
			b_d['self'] = "/boat/" + id
			self.response.write(json.dumps(b_d)) 
					
	def delete(self, id=None): #delete boat, empty slip
		if id: 
			b = ndb.Key(urlsafe=id).get()
			boat_dict = b.to_dict()
			
			#Changes Slip information
			slip = Slip.query(Slip.current_boat == boat_dict['name']).get()
			#departure =  '2/20/2018: ' + slip.current_boat
			#slip.departure_date = slip.departure_date + departure
			slip.current_boat = 'empty'
			slip.arrival_date = 'none'
			slip.put()
			#Delete boat
			b.key.delete()
			
	#updates the boat's length, type if needed 
	def patch(self, id=None):   #{need name, length or type}
		if id:
			boat_check= ndb.Key(urlsafe=id).get()
			boat_info = boat_check.to_dict() 
			self.response.write(json.dumps(boat_info)) 
			boat_change = json.loads(self.request.body)
			if boat_change['length'] != null:
				new_length = boat_change['length']
				boat_update = ndb.Key(urlsafe=id).get()
				boat_update.length= new_length
				boat_update.put()
			elif boat_change['type'] != none:
				new_type = boat_change['type']
				boat_update = ndb.Key(urlsafe=id).get()
				boat_update.type= new_type
				boat_update.put()
			elif boat_change['name'] != null:
				new_name = boat_change['name']
				boat_update = ndb.Key(urlsafe=id).get()
				boat_update.type= new_name
				boat_update.put()
			boat_newInfo = boat_update.to_dict() 
			self.response.write(json.dumps(boat_newInfo)) 
		
class SlipAssignHandler(webapp2.RequestHandler):	#get list of boats, assign boat, delete boat
	def get(self, id=None): 
		if id: 
			s = ndb.Key(urlsafe=id).get() 
			s_d = s.to_dict() 
			s_d['self'] = "/slip/" + id
			self.response.write(json.dumps(s_d)) 
					
	#assign boat to slip and set at_sea to false    slip/assign/slip.key
	def patch(self, id=None):   #boat name:(current_boat) and arrival_date are needed in body
		if id:
			#old slip information  Slip Key is needed in URL  
			slip_assign = ndb.Key(urlsafe=id).get()
			slip_data = slip_assign.to_dict()
			slip_request = json.loads(self.request.body)
			space = " \n"  #creates a space in the output
			slipDetail = "Slip Assignment: " 
			boatDetail = "Boat Assignment Verification: " 
			if slip_data['current_boat'] == 'empty': #if the current slip is empty add boat
				#add boat name
				new_boat = slip_request['current_boat']
				new_date = slip_request['arrival_date']
				slip_update = ndb.Key(urlsafe=id).get()
				slip_update.current_boat = new_boat
				slip_update.arrival_date = new_date
				slip_update.put()
				slip_newInfo = slip_update.to_dict()
				self.response.write(str(slipDetail))
				self.response.write(json.dumps(slip_newInfo))
				self.response.write(str(space))
				
				#changes boat at_sea to false
				boat = Boat.query(Boat.name == new_boat).get()
				boat.at_sea = 'False'
				boat.put()
				boat_info = boat.to_dict() 
				self.response.write(str(boatDetail))
				self.response.write(json.dumps(boat_info))
				self.response.write(str(space))	
			
			elif slip_data['current_boat'] == slip_request['current_boat']:  #if slip has this boat
				self.response.write('Error')
			else:
				#shows all the slips and boat names
				slips = Slip.query()  
				for slip in slips:
					if slip.current_boat == 'empty': #find a slip that is empty and add boat
						#add boat name
						new_boat = slip_request['current_boat']
						new_date = slip_request['arrival_date']
						slip_update = ndb.Key(urlsafe=id).get()
						slip_update.current_boat = new_boat
						slip_update.arrival_date = new_date
						slip_update.put()
						slip_newInfo = slip_update.to_dict()
						self.response.write(str(slipDetail))
						self.response.write(json.dumps(slip_newInfo))
						self.response.write(str(space))
				
						#changes boat at_sea to false
						boat = Boat.query(Boat.name == new_boat).get()
						boat.at_sea = 'False'
						boat.put()
						boat_info = boat.to_dict() 
						self.response.write(str(boatDetail))
						self.response.write(json.dumps(boat_info))
						self.response.write(str(space))

class EmptySlipHandler(webapp2.RequestHandler):	#set boat to at_sea and empty slip  USING slip/slip.key
	def patch(self, id=None):				#need the departure_date and current_boat
		if id:
			#old information  Slip Key is needed in URL
			slip_check = ndb.Key(urlsafe=id).get()
			slip_info = slip_check.to_dict()
			slipHist = "Current Slip History:  " 
			self.response.write(str(slipHist))
			space = " \n"  #creates a space in the output
			self.response.write(json.dumps(slip_info))
			self.response.write(str(space))
			
			#changes boat at_sea to true
			boat = Boat.query(Boat.name == slip_info['current_boat']).get()
			boat.at_sea = 'True'
			boat.put()
			boat_info = boat.to_dict() 
			boatData = "Updated Boat Data:  " 
			self.response.write(str(boatData))
			self.response.write(json.dumps(boat_info))
			self.response.write(str(space))
			
			#new slip updates current_boat=empty and arrival_date=null, departure_history=date 
			#new boat updates at_sea= True
			slip_request = json.loads(self.request.body)
			slip_update = ndb.Key(urlsafe=id).get()
			slip_update.current_boat = 'empty'
			slip_update.arrival_date = 'none'
			new_date = slip_request['departure_date']
			slip_update.departure_history = new_date
			slip_update.put()
			slip_newInfo = slip_update.to_dict()
			slipData = "Updated Slip Data:  " 
			self.response.write(str(slipData))
			self.response.write(json.dumps(slip_newInfo))
							
class SlipDeleteHandler(webapp2.RequestHandler):	#get list of boats, assign boat, delete boat
	def delete(self, id=None): #delete slip, change boat: at_sea=true; slip_num=none  
		if id: 
			s = ndb.Key(urlsafe=id).get()
			slip_dict = s.to_dict()
			
			#Changes Boat information
			boat = Boat.query(Boat.name == slip_dict['current_boat']).get()
			boat.at_sea = 'true'
			boat.put()
			
			#Delete slip
			s.key.delete()
							
class MainPage(webapp2.RequestHandler):
	def get(self):
		self.response.write("Boat and Slip App")
		
allowed_methods = webapp2.WSGIApplication.allowed_methods
new_allowed_methods = allowed_methods.union(('PATCH',))
webapp2.WSGIApplication.allowed_methods = new_allowed_methods
		
app = webapp2.WSGIApplication([
    ('/', MainPage),
	('/boat', BoatHandler),
	('/slip', SlipHandler),
	('/boat/all', BoatListHandler),
	('/boat/modify/(.*)', BoatModifyHandler),
	('/boat/(.*)', BoatHandler),
	('/slip/all', SlipListHandler),
	('/slip/assign/(.*)', SlipAssignHandler),
	('/slip/delete/(.*)', SlipDeleteHandler),
	('/slip/empty/(.*)', EmptySlipHandler),
	('/slip/history/(.*)', SlipDepartHandler),
	('/slip/(.*)', SlipHandler)
], debug=True)
