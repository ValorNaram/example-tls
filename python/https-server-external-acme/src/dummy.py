#/bin/python3
# Example taken from https://hub.docker.com/r/smallstep/step-ca and highly modified
from http.server import BaseHTTPRequestHandler
import ssl, signal, socketserver, os, logging

keyfile=os.getenv("TLS_KEY_LOCATION")
certfile=os.getenv("TLS_CERT_LOCATION")
ca_certs=os.getenv("TLS_CA_CERT_LOCATION")

logging.basicConfig(format='%(levelname)s (dummy server): \x1b[0;36m%(message)s\x1b[0;m', level=logging.DEBUG)

sslContext = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)

class HelloHandler(BaseHTTPRequestHandler):

	server_version = "arrow-dummy/1.0.0"

	def do_GET(self):
		self.send_response(200);
		self.send_header('content-type', 'text/html; charset=utf-8');
		self.end_headers()
		self.wfile.write(b'Welcome to the bright world of encryption :)')

httpd = socketserver.TCPServer(('', 443), HelloHandler)

def reloadCert(signum, frame):
	logging.info("loading certificate ...")
	sslContext.load_cert_chain(certfile, keyfile=keyfile)
	sslContext.load_verify_locations(cafile=ca_certs)

httpd.socket = sslContext.wrap_socket(httpd.socket, server_side=True)
reloadCert(None, None)

signal.signal(signal.SIGHUP, reloadCert)

sfile = open("dummy.pid", "w")
sfile.write(str(os.getpid()))
sfile.close()

logging.info("Dummy HTTP server suitable for testing")

httpd.serve_forever()