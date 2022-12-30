#!/usr/bin/env bash

# Clean up resources when the script is interrupted
trap 'rm -f burp' INT TERM EXIT

if [[ $EUID -eq 0 ]]; then
    if [[ ! -f "${Burp_Suite_Pro}" ]]; then
        # Download Burp Suite Profesional Latet Version
        echo 'Downloading Burp Suite Professional ....'
        Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=&type=jar"
        curl "$Link" -o Burp_Suite_Pro.jar --silent --progress-bar
        sleep 2
    fi

    # execute Keygenerator
    echo 'Starting Keygenerator'
    (java -jar keygen.jar) &
    sleep 3s
    
    # Execute Burp Suite Professional with Keyloader
    echo 'Executing Burp Suite Professional with Keyloader'
    echo "java --illegal-access=permit -Dfile.encoding=utf-8 -javaagent:$(pwd)/loader.jar -noverify -jar $(pwd)/Burp_Suite_Pro.jar &" > burp
    chmod +x burp
    cp burp /bin/burp
    (./burp)
else
    echo "Execute Command as Root User"
    exit
fi
