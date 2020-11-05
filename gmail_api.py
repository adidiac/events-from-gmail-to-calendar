from __future__ import print_function
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import base64  
# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']

def search_from(lista):
    for i in lista:
        if i["name"]=="From":
            return i["value"]
def search_subject(lista):
    for i in lista:
        if i["name"]=="Subject":
            return i["value"]

def search_date(lista):
     for i in lista:
        if i["name"]=="Date":
            return i["value"]
def main():
    """Shows basic usage of the Gmail API.
    Lists the user's Gmail labels.
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('gmail', 'v1', credentials=creds)

    # Call the Gmail API
    

    results = service.users().messages().list(userId='me',labelIds = ['INBOX']).execute()
    messages = results.get('messages', [])
    file=open("Mail-uri.txt","a",encoding="utf8")
    for message in messages:
            msg = service.users().messages().get(userId='me', id=message['id']).execute()
            file.write(', '.join(msg["labelIds"]))
            file.write("\n")
            file.write(search_from(msg["payload"]["headers"]))
            file.write("\n")
            file.write(search_date(msg["payload"]["headers"]))
            file.write("\n")
            file.write(search_subject(msg["payload"]["headers"]))
            file.write("\n")
            file.write("\n")
            if "parts" in msg['payload']:
                text=base64.urlsafe_b64decode(msg['payload']['parts'][0]['body'].get("data").encode("ASCII")).decode("utf-8")
            file.write(text)
            file.write('\n\n *new email*')
            file.write('\n')

if __name__ == '__main__':
    main()