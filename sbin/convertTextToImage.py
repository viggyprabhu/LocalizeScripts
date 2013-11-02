#!/usr/bin/python 

import PIL
import os,sys
from PIL import ImageFont
from PIL import Image
from PIL import ImageDraw
def createImage(strings, fileName):

   img=Image.new("RGBA", (800,600),(255,255,255))
   draw = ImageDraw.Draw(img)
   col = 0;	
   for string in strings:
      if(string):
	col+=100;	
        string = str(string).strip('\n')  
        draw.text((15, col),string,(0,0,0),font=font)
   draw = ImageDraw.Draw(img)
   img.save(fileName+".png")
pathname = os.path.dirname(__file__) 
dirname = os.path.abspath(pathname)
imageDir = dirname+"/../images/"
tmpDir = dirname+"/../tmp/"	
unlocalizedFile = tmpDir+"/unlocalized.txt"
print unlocalizedFile;
fontType ="/usr/share/fonts/truetype/ttf-liberation/LiberationSerif-Bold.ttf"; 

font = ImageFont.truetype(fontType,14)
project = "GNU_Health"

with open(unlocalizedFile) as f:
   content = f.readlines()
arr=['']*5
index=0

for string in content:
   index+=1
   subIndex = index%5
   string = str(index)+". "+string	
   if(subIndex==0):
	arr[subIndex-1]=string
	createImage(arr,imageDir+"/"+project+str(index/5))
	arr=['']*5
   else:
        arr[subIndex-1]=string   


createImage(arr,imageDir+"/"+project+str(index/5+1))
