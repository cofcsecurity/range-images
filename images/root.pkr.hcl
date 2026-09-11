/* 
This is the root file for the packer images. 

Packer Block -
    Here are defined the plugins block. 
    This just tells packer you want to use AWS to launch your images too

*/

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

