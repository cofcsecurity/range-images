CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EXIT;
