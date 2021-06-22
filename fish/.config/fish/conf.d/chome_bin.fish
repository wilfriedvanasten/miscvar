if not set -q CHROME_BIN
  and test -x /bin/chromium
  set -xg CHROME_BIN /bin/chromium
end
