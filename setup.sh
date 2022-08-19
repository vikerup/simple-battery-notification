sudo apt install ruby-notify

cat <<EOT > ~/.config/bat0.sh
#!/bin/sh

# requires apt install ruby-notify

CAPACITY=\$(cat /sys/class/power_supply/BAT0/capacity)

STATUS=\$(cat /sys/class/power_supply/BAT0/status)

[ "\$STATUS" = "Discharging" ] && [ "\$CAPACITY" -lt 15 ] && \

/usr/bin/notify-send -u critical -a power_supply_low "Low Battery" "You are running low on battery (\$CAPACITY%).\nPlease plug in the charger." && \

echo "Low Battery notification sent" || \
echo "Low Battery notification not sent. \$CAPACITY"
EOT

chmod +x ~/.config/bat0.sh

mkdir -p ~/.config/systemd/user

cat <<EOT > ~/.config/systemd/user/battery-notification.service
[Unit]
Description=Low battery notification service

[Service]
Type=Simple
ExecStart=/bin/bash %h/.config/bat0.sh
Retart=always
RestartSec=30
Environment="DISPLAY=:0" "XAUTHORITY=%h/.Xauthority

[Install]
WantedBy=default.target
EOT

systemctl --user enable battery-notification.service
systemctl --user start battery-notification.service
