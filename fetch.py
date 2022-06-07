import requests
from lxml import etree

content = requests.get("https://mcversions.net/").content.decode()

html = etree.HTML(content)

vers = []
keys = []

"""
1 is for stable release
2 is for snapshot preview, and many of them are not available
3 and 4 are beta and alpha respectively, but none of them are available, so skipped

If `only_stable` flag is enabled, the script will only fetch stable releases to versions.txt, which is faster.

To see all available versions, run this script and check out versions.txt
"""
only_stable = True
for i in range(1, 2 if only_stable else 3):
    div = html.xpath(f"/html/body/main/div/div[2]/div[{i}]/div")[0]
    for child in div.getchildren():
        if child.get("id"):
            link = "https://mcversions.net" + child.getchildren()[1].getchildren()[0].get("href")
            print(f"Checking {child.get("id")}:")
            download_page = requests.get(link).content.decode()
            download_page_html = etree.HTML(download_page)
            try:
                k = download_page_html.xpath("/html/body/main/div/div[1]/div[2]/div[1]/a")[0].get("href")
            except:
                print("Version is not downloadable.")
            else:
                vers.append(child.get("id"))
                keys.append(k)
                print(f"Download link found: {key[-1]}")

pairs = list(zip(ver, key))
with open("versions.txt", "w") as f:
    for v, k in pairs:
        f.write(f"{v} {k}\n")

print("The fetching process is done, check out versions.txt for all available versions.")
