#!/usr/bin/env python



from google.appengine.ext import webapp
from google.appengine.ext.webapp import util


from google.appengine.api import memcache
from google.appengine.api import datastore
from google.appengine.api import urlfetch
from google.appengine.ext import db

import simplejson as json

total_itens = 30 #total de colunas



def generateMusic():
	music = {}
	music["do"] = []
	music["re"] = []
	music["mi"] = []
	music["fa"] = []
	music["sol"] = []
	music["la"] = []
	music["si"] = []
	
	for indice in range(32):
		music["do"].append(False)
		music["re"].append(False)
		music["mi"].append(False)
		music["fa"].append(False)
		music["sol"].append(False)
		music["la"].append(False)
		music["si"].append(False)
	return music
	

class Parametro(db.Model):
	playing = db.BooleanProperty(required=True,default=False)
	created = db.DateTimeProperty(auto_now_add=True)
	updated = db.DateTimeProperty(auto_now=True)
	music = db.TextProperty()
	url = db.LinkProperty(default="http://caipirinha-hangout.appspot.com/")
	



def get_param():
	parametro = memcache.get("parametro")
	if parametro is not None:
		return parametro
	else:
		parametro = Parametro.get_or_insert(key_name="PARAMETRO", music=json.dumps(generateMusic()))
		memcache.add("parametro", parametro)
		return parametro
	


class PushHandler(webapp.RequestHandler):
	def get(self, note, index, active):
		self.response.headers.add_header("Access-Control-Allow-Origin", "*")
		
		parametro = get_param()
		music = json.loads(parametro.music)
		music[note][int(index)] = active == "1"
		parametro = Parametro.get_or_insert(key_name="PARAMETRO")
		parametro.music = json.dumps(music)
		parametro.put()
		
		memcache.replace("parametro", parametro)
		self.response.out.write("OK USER")
		
		
		
class GetHandler(webapp.RequestHandler):
	def get(self):
		parametro = get_param()
		music = json.loads(parametro.music)
		
		for linha in music:
			self.response.out.write("%s=" % linha)
			for valor in music[linha]:
				self.response.out.write(valor and "1" or "0")
			self.response.out.write("\n")
		
class PlayHandler(webapp.RequestHandler):
	def get(self):
		parametro = get_param()
		if parametro.playing:
			self.response.out.write("1\n")
		else:
			self.response.out.write("0\n")




class RefreshHandler(webapp.RequestHandler): #force clean cache
	def get(self):
		parametro = get_param()
		parametro.music = json.dumps(generateMusic())
		parametro.put()
		memcache.delete("parametro")
	


def main():
	handler_list = [
		("/push/([\w\d]{2,10})/([\d]{1,2})/(0|1)/", PushHandler),
		("/get/", GetHandler),
		("/play/", PlayHandler),
		("/refresh", RefreshHandler),
	]
	
	application = webapp.WSGIApplication(handler_list, debug=True)
	util.run_wsgi_app(application)


if __name__ == '__main__':
	main()
