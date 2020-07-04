from bs4 import BeautifulSoup as bs
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

url = "https://referensi.data.kemdikbud.go.id/"


def getLink(path):
    dic = {}
    html = requests.get(url+path, verify=False)
    soup = bs(html.text, 'html.parser')
    for link in soup.find_all('a'):
        if "index11.php?kode=" in link.get('href'):
           dic[link.get('href')] = str(link.text)
    return dic

def getSekolah(path):
    dic = {}
    jenjang = ["13","15","16"]
    for i in jenjang:
        html = requests.get(url+path+"&id="+i, verify=False)
        soup = bs(html.text.replace("&nbsp;", ""), 'html.parser')
        table_sekolah = soup.find("table", attrs={"class":"display"}).find_all("tr")
        for it in range(len(table_sekolah)):
            if it == 0:
                continue
            tabs = table_sekolah[it].find_all("td")[1].a.get('href')
            nama = table_sekolah[it].find_all("td")[2].text
            dic[tabs] = nama
        return dic

def getContact(path):
    html = requests.get(url+path, verify=False)
    soup = bs(html.text.replace("&nbsp;", ""), 'html.parser')
    table_sekolah = soup.find("div", attrs={"id":"tabs-6"}).find_all("td")
    email = table_sekolah[8].text
    website = table_sekolah[12].text
    return email+" : "+website 


for url_kab, kab_kota in  getLink("index11.php?kode=320000").items():
    print(" =========================== ",kab_kota," =========================== ")
    for url_kec, kec in  getLink(url_kab).items():
        for tabs, nama in  getSekolah(url_kec).items():
            print(getContact(tabs), " : ", nama)




