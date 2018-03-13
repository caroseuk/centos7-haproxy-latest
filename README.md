# HAProxy (From Source) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/f3a34d12806e4f8692499b01714e4016)](https://www.codacy.com/app/caroseuk/centos7-haproxy-latest?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=caroseuk/centos7-haproxy-latest&amp;utm_campaign=Badge_Grade)
## Downloads/builds and installs HAProxy from Source on CentOS 7.
### Tested on CentOS 7.4 (Digital Ocean)
This is a simple BASH script that prompts the user for a prefered HAProxy version (List available on HAProxy website), downloads/builds and installs from source. 
<br />
**Please feel free to enhance this script and send any pull requests.**

# How to use

- Run this script as root.

 1. Clone the repo
 2. Copy script to home directory
 3. ensure the script has the correct permission to be run
 ```bash
 chmod u+x haproxy-install.sh
 ```
 4. Run the script
 ```bash
 ./haproxy-install.sh
 ```
 5. Follow the prompts
 6. Enjoy!

#### Install location
Upon completion of this script, an example configurtation file will be copied to **/etc/haproxy/haproxy.cfg**. Prior to running HAProxy, you will need to add the relevant details for your environment.

The HAProxy binary is installed in the **/usr/sbin** folder
