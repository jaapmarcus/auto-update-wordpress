#!/bin/bash

# List users 
users=$(/usr/local/hestia/bin/v-list-users plain | awk '{print $1}')
for user in $users
do
    echo $user
    # List domains
    domains=$(/usr/local/hestia/bin/v-list-web-domains $user plain | awk '{print $1}')
    for domain in $domains
    do
        echo "- $domain"
        # Check if WordPress is installed
        if [ -d /home/$user/web/$domain/public_html/wp-admin ]; then
            # Check if WordPress is up to date
            result=$(sudo -u $user /home/$user/.wp-cli/wp core check-update --format=count --path=/home/$user/web/$domain/public_html)
	        if [ "$result" != "" ]; then
                sudo -u $user /home/$user/.wp-cli/wp core update --path=/home/$user/web/$domain/public_html
            fi
            sudo -u $user /home/$user/.wp-cli/wp plugin update --all --path=/home/$user/web/$domain/public_html
            sudo -u $user /home/$user/.wp-cli/wp theme update --all --path=/home/$user/web/$domain/public_html
        fi
    done
done;