var thread
func _init():
	thread = Thread.new()
	thread.start(self,"_t")

func _t(u):
	var err=0
	var http = HTTPClient.new()
	var err = http.connect("api.twitch.tv",443)
	print(err)

	while(http.get_status()==HTTPClient.STATUS_CONNECTING
	or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)
	
	print("status: ",http.get_status())
	print("code: ",http.get_response_code())
	
	var headers=[
		"User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]
	
	print("reg: ",http.request(HTTPClient.METHOD_GET,"/kraken/streams",headers))
	print("code: ",http.get_response_code())
	
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)
	
	print("response? ",http.has_response())
	print("status: ",http.get_status())
	print("code: ",http.get_response_code())
	print(http.get_response_headers_as_dictionary())
	
	http.close()
