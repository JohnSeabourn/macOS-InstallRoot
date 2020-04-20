#!/bin/bash

prompt() {
    dialogTitle="macOS InstallRoot"
    authPass=$(/usr/bin/osascript <<EOT
        tell application "System Events"
            activate
            repeat
                display dialog "This application requires administrator privileges. Please enter your administrator account password below to continue:" ¬
                    default answer "" ¬
                    with title "$dialogTitle" ¬
                    with hidden answer ¬
                    buttons {"Quit", "Continue"} default button 2
                if button returned of the result is "Quit" then
                    return 1
                    exit repeat
                else if the button returned of the result is "Continue" then
                    set pswd to text returned of the result
                    set usr to short user name of (system info)
                    try
                        do shell script "echo test" user name usr password pswd with administrator privileges
                        return pswd
                        exit repeat
                    end try
                end if
            end repeat
        end tell
    EOT
    )

    if [ "$authPass" == 1 ]
    then
        osascript -e 'tell application "System Events"' -e 'activate' -e 'display dialog "User aborted." buttons {"OK"}' -e 'end tell'
        /bin/echo "User aborted. Exiting..."
        exit 0
    fi

    sudo () {
        /bin/echo $authPass | /usr/bin/sudo -S "$@"
    }
}

prompt

dodcerts=(
    "DOD EMAIL CA-33.cer"
    "DOD EMAIL CA-43.cer"
    "DOD EMAIL CA-59.cer"
    "DOD ID CA-42.cer"
    "DOD ID CA-52.cer"
    "DOD ID SW CA-45.cer"
    "DOD SW CA-53.cer"
    "DOD EMAIL CA-34.cer"
    "DOD EMAIL CA-44.cer"
    "DOD ID CA-33.cer"
    "DOD ID CA-43.cer"
    "DOD ID CA-59.cer"
    "DOD ID SW CA-46.cer"
    "DOD SW CA-54.cer"
    "DOD EMAIL CA-39.cer"
    "DOD EMAIL CA-49.cer"
    "DOD ID CA-34.cer"
    "DOD ID CA-44.cer"
    "DOD ID SW CA-35.cer"
    "DOD ID SW CA-47.cer"
    "DOD SW CA-55.cer"
    "DOD EMAIL CA-40.cer"
    "DOD EMAIL CA-50.cer"
    "DOD ID CA-39.cer"
    "DOD ID CA-49.cer"
    "DOD ID SW CA-36.cer"
    "DOD ID SW CA-48.cer"
    "DOD SW CA-56.cer"
    "DOD EMAIL CA-41.cer"
    "DOD EMAIL CA-51.cer"
    "DOD ID CA-40.cer"
    "DOD ID CA-50.cer"
    "DOD ID SW CA-37.cer"
    "DOD SW CA-60.cer"
    "DOD SW CA-57.cer"
    "DOD EMAIL CA-42.cer"
    "DOD EMAIL CA-52.cer"
    "DOD ID CA-41.cer"
    "DOD ID CA-51.cer"
    "DOD ID SW CA-38.cer"
    "DOD SW CA-61.cer"
    "DOD SW CA-58.cer"
)

rootcerts=(
    "DoDRoot2.cer"
    "DoDRoot3.cer"
    "DoDRoot5.cer"
    "DoDRoot4.cer"
)

cd $HOME/Downloads
curl -O https://militarycac.com/maccerts/AllCerts.zip
yes | unzip AllCerts.zip

for certs in "${rootcerts[@]}"
do
    echo "Importing ${certs}"
    sudo /usr/bin/security add-trusted-cert -d -r trustRoot -k $HOME/Library/Keychains/login.keychain-db $HOME/Downloads/$certs
    rm $HOME/Downloads/$certs
done

for cert in "${dodcerts[@]}"
do
    arrays=( "${cert[@]}" )
    for item in "${arrays[@]}"
    do
        echo "Importing ${item}"
        sudo /usr/bin/security add-trusted-cert -d -r trustAsRoot -k $HOME/Library/Keychains/login.keychain-db $HOME/Downloads/"${item}"
        rm $HOME/Downloads/"${item}"
    done
done
osascript -e 'tell application "System Events"' -e 'activate' -e 'display dialog "Certificates installed successfully." buttons {"OK"}' -e 'end tell'
echo "Cleaning up system"
rm AllCerts.zip
