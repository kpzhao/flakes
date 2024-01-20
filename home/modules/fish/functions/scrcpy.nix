''
  function nuwa
    set IP 192.168.3.9
    for i in $IP
      adb connect $i:$(nmap $i -p 37000-44000 | awk "/\/tcp/" | cut -d/ -f1)
    end
    for i in $(adb devices | awk '{print $1}' | grep 192)
      scrcpy -s $i -w -S &
    end
  end
''
