import smtplib,string,random,time,sys
sender = "email@email.com"
passwd = "password"
#fd = open('mail.txt', 'r')
#emails =  fd.readlines()

def generate_random_subject():
    return "Subject: " + ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(random.randint(5,30))) + "\n\n"

def generate_random_mail():
    return ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(random.randint(100,500))) + "\n\n"
def automated_mail(list):
    for email in list:
        try:
            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.starttls()
            server.login(sender, passwd)
            server.sendmail(sender, email, generate_random_subject() + generate_random_mail() )
            server.quit()
            print("Mail sent to " + email)
            time.sleep(random.randint(15,60))
        except:
            print("Error sending mail to " + email)

    

if __name__ == "__main__":
    mails = sys.argv[1:]
    for i in range(100):
        automated_mail(mails)