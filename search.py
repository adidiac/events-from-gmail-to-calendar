import datetime
import json
types=['Meeting','Intalnire','Adunare']

def main():
    #f=open('config.txt','r')
    #path=f.readline()
    #complete_path=path+'\\'+datetime.datetime.now().strftime("%m/%d/%y")
    numar_eventuri=0
    fisier_config=open('Numar_eventuri.txt','w')
    fisier_eventuri=open('Lista_Eventuri.txt')
    f=open('Index.txt')
    events=open("events.txt",'w')
    for i in f:
        i=i[:-1]
        g=open(i)
       
        g.readline()
        g.readline()
        g.readline()
        subject=g.readline()

        event={}

        for j in g:
            lista=j.split()
            for k in lista:
                for l in types:
                    if k.startswith(l):
                        meeting=k.split(':')
                        event={
                        "summary": subject,
                        "location": "",
                        "description": "",
                        "start": {
                            "dateTime": meeting[1],
                            "timeZone": "Romania"
                        },
                        "end": {
                            "dateTime": "",
                            "timeZone": "Romania"
                        },
                        "recurrence": [
                            "RRULE:FREQ=DAILY;COUNT=2"
                        ],
                        "attendees": [
                        ],
                        "reminders": {
                            "useDefault": "False",
                            "overrides": [
                            {
                                "method": "email", 
                                "minutes": "1240"
                            },
                            {
                                "method": "popup", 
                                "minutes": 10
                            }
                            ]
                        }
                    }
                    res=not event
                    if str(res) == False:
                        numar_eventuri+=1
                        fisier_eventuri.write(str(numar_eventuri)+' '+i[:-1]+' '+event['summary']+'\n')
                        json.dump(event,events)
                        events.write("\n")
    
    fisier_config.write(str(numar_eventuri))

                    
    
if __name__ == '__main__':
    main()

