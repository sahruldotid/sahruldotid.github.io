certspotter(){
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} 

crtsh(){
curl -s https://crt.sh/?q=%.$1  | sed 's/<\/\?[^>]\+>//g' | grep $1
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1  | nmap -T5 -Pn -sS -i - -$
} 

file_brute(){
cat $1 | while read line; do python3 /home/syahrul/dirsearch/dirsearch.py -x 500,400,401,419,502,503,501 -t 200 -e php,html,asp,aspx,jsp,zip,bak,js -u "$line" --plain-text-report=`echo "$line" | sed 's/https//g' | tr -d "/,:"`; done
}


ipinfo(){
curl http://ipinfo.io/$1
}

port_brute(){
cat $1 | while read line; do nmap -p- $line --min-rate 40000 -T4 --max-retries 2; done
}


#------ Tools ------
dirsearch(){
python3 /home/syahrul/dirsearch/dirsearch.py -t 200 -e php,html,asp,aspx,jsp,zip,bak,js -u $1
}

sqlmap(){
python /home/syahrul/sqlmap/sqlmap.py --url $1 --dbs
}

linkfinder(){
python /home/syahrul/linkfinder/linkfinder.py -i $1 -o cli
}

dex2jar(){
/home/syahrul/dex2jar/dex2jar $1
}


delete_dupe(){
ruby -e 'http://STDIN.read.lines.sort!.reverse!.uniq! { |x| x.split(%r{https?://}).last }.each { |x| puts x }'
}

cname(){
input="$1"
while IFS= read -r line
do
  host "$line" | grep alias
done < "$input"
}

http_listen(){
ssh -R 80:localhost:$1 ssh.localhost.run
}

available_tool(){
echo "cerspotter domain"
echo "crtsh domain"
echo "certnmap domain"
echo "file_brute domain_list.txt"
echo "port_brute domain_list.txt"
echo "dirsearch url"
echo "sqlmap url"
echo "linkfinder url"
echo "dex2jar apk"
echo "waybackurls"
echo "httprobe"
echo "meg"
echo "wpscan"
echo "apktool"
echo "amass"
echo "trufflehog"
echo "aquatone"
echo "assetfinder"
echo "ffuf"
echo "hakrawler"
echo "cname FILENAME"
echo "smuggler.py"
echo "arjun param finder"
echo "http_listen [port]"

}

export PATH=$PATH:/home/syahrul/go/bin:/usr/local/go/bin/:/usr/local/nvidia/bin:/usr/local/cuda/bin:/tools/node/bin:/tools/google-cloud-sdk/bin:/opt/bin
