var thread
func _init():
	thread = Thread.new()
	thread.start(self,"_t")

func _t(u):
	var err=0
	var http = HTTPClient.new()
	var err = http.connect("mjrb.dyndns.org",8080)#,true,true)
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
		"Accept: application/json"
	]
	
	print("reg: ",http.request(HTTPClient.METHOD_GET,"/WNG/resources/greeting",headers))
	print("code: ",http.get_response_code())
	
	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		http.poll()
		print("Requesting..")
		OS.delay_msec(500)
	
	print("response? ",http.has_response())
	print("status: ",http.get_status())
	print("code: ",http.get_response_code())
	print(http.get_response_headers_as_dictionary())
	
	var rb = RawArray()
	while(http.get_status()==http.STATUS_BODY):
		http.poll()
		var chunk = http.read_response_body_chunk()
		if (chunk.size()==0):
			OS.delay_usec(1000)
		else:
			rb = rb + chunk
	
	var j = {}
	j.parse_json(rb.get_string_from_utf8())
	print(j)
	
	
	http.close()
