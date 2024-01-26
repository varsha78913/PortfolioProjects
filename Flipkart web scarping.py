#!/usr/bin/env python
# coding: utf-8

# In[ ]:


pip install requests


# In[ ]:


pip install bs4


# In[ ]:


import requests
from bs4 import BeautifulSoup


# In[126]:


phn_nm = []
phn_pr = []
#phn_rtng_rev =[]



page_num = input("Enter number of pages")
for i in range(1,int(page_num)+1):
    url = "https://www.flipkart.com/search?q=phone&otracker=search&otracker1=search&marketplace=FLIPKART&as-show=on&as=off"+str(i)
    req = requests.get(url)
    content = BeautifulSoup(req.content,'html.parser')
    print(content)
    name = content.find_all('div',{"class":"_4rR01T"})
    price = content.find_all('div',{"class":"_30jeq3 _1_WHN1"})
    #rating_review = content.find_all('div',{"class":"gUuXy-"})
    print("Phone  in Page" + str(i))
    print(len(name))
    
    
    for i in name:
        phn_nm.append(i.text)
    for i in price:
        phn_pr.append(i.text)
   # for i in rating_review:
        #phn_rtng_rev.append(i.text)
  


# In[127]:


pip install pandas as pd


# In[128]:


import pandas as pd


# In[133]:


df = pd.DataFrame({"Phone Name":phn_nm, "Phone Price":phn_pr})


# In[138]:


df


# In[139]:


import csv


# In[140]:


df.to_csv('flipkart.csv')


# In[ ]:





# In[ ]:




