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
cat $1 | while read line; do python3 /home/syahrul/dirsearch/dirsearch.py -x 500,400,401,419 -t 200 -e php,html,asp,aspx,jsp,zip,bak,js -u "$line" --plain-text-report=`echo "$line" | sed 's/https//g' | tr -d "/,:"`; done
}


ipinfo(){
curl http://ipinfo.io/$1
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

available_tool(){
echo "cerspotter domain"
echo "crtsh domain"
echo "certnmap domain"
echo "file_brute domain_list.txt"
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


}

export PATH=$PATH:/home/syahrul/go/bin
