#!/bin/bash

#!/usr/local/bin/pod lib create "${1}"

cd "${2}"
swift package init
swift package generate-xcodeproj
git remote add origin "${3}"
#!/usr/local/bin/pod lib lint --allow-warnings
#!/usr/local/bin/pod trunk register voidilov@gmail.com 'dankinsoid' --description='macbook pro'
#!/usr/local/bin/pod trunk push "${1}".podspec --allow-warnings
