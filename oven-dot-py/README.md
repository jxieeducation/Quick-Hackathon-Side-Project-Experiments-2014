oven-dot-py
==============

oven-dot-py is a python api that is built on top of the AT&T library (SPEECH, SMS and PAYMENT), which enables any smartphones or websites to control hardware with ease.   
   
*setup:*   
bash getauth   
||copy down the token||   
python -i oven.py   
set_token(||token||)   
set_port(0, "lamp")   
set_port(1, "coffee maker")   

example usages:   
**control device by speech**   
voice_to_text("mypath/TURN ON THE LAMP.wav")   
    
**control device by text**   
set_text_inbox(||number||)   
||text the number / id --> TURN OFF THE LAMP||   
text_get()   

**payment by text**   
text_get_with_payment()
||text the number / id --> MAKE THE COFFEE MAKER ON AND MAKE COFFEE\n235123123 is my online transaction number||   


*testing:*   
cd test   
python *.py   
   

**see sample app at oven.html & sampleapp.py for more integration information**
