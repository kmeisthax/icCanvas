#!/usr/bin/env python

import sys, urllib2, subprocess, os, os.path
from os.path import basename
from urlparse import urlsplit

def url2name(url):
    return basename(urlsplit(url)[2])

def download(url, localFileName = None):
    localName = url2name(url)
    req = urllib2.Request(url)
    r = urllib2.urlopen(req)
    if r.info().has_key('Content-Disposition'):
        # If the response has Content-Disposition, we take file name from it
        localName = r.info()['Content-Disposition'].split('filename=')[1]
        if localName[0] == '"' or localName[0] == "'":
            localName = localName[1:-1]
    elif r.url != url:
        # if we were redirected, the real file name we take from the final URL
        localName = url2name(r.url)
    if localFileName:
        # we can force to save the file as specified name
        localName = localFileName
    f = open(localName, 'wb')
    f.write(r.read())
    f.close()

    return localName

download_dir = os.getcwd()
localName = download(sys.argv[1])
localTarName = os.path.splitext(localName)[0]
localDirName = os.path.splitext(localTarName)[0]

subprocess.check_call(["xz", "-kd", os.path.join(download_dir, localName)])
subprocess.check_call(["tar", "-xf", os.path.join(download_dir, localTarName)])
subprocess.check_call(["rmdir", sys.argv[3]])
subprocess.check_call(["mv", localDirName, sys.argv[3]])
