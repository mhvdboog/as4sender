# AS4 Sender Script
The [Digital Business Council](http://digitalbusinesscouncil.com.au) (DBC) in Australia has published a specification for a payload agnostic messaging standard. This repository provides a very limited AS4 client script to test connectivity with an access point. An AS4 conformant access point can be configured to support the DBC standard. This script may help test connectivity and configuration of an access point.

## Usage
The AS4 header provided in this repository is conformant the Digital Business Council specification except for one difference. This AS4 header template adds the originalSender and finalRecipient message properties to indicate corner 1 and corner 4 party id's. Some existing AS4 implementations require the To/PartyId and From/PartyId to be the corners 3 and 4.

Examples:
```bash
./send.sh https://access.point.url:port/service
```
```bash
./send.sh https://access.point.url:port/service | xmllint --format -
```

## AS4 Header Template
The AS4 header template can easily be changed to fit your specific action and service values and senders and receivers.
```xml
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:eb="http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/">
  <soap:Header>
    <eb:Messaging soap:mustUnderstand="true">
      <eb:UserMessage>
        <eb:MessageInfo>
          <eb:Timestamp></eb:Timestamp>
          <eb:MessageId></eb:MessageId>
        </eb:MessageInfo>
        <eb:PartyInfo>
          <eb:From>
            <eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:iso6523:0151">corner2-abn</eb:PartyId>
            <eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/defaultRole</eb:Role>
          </eb:From>
          <eb:To>
            <eb:PartyId type="urn:oasis:names:tc:ebcore:partyid-type:iso6523:0151">corner3-abn</eb:PartyId>
            <eb:Role>http://docs.oasis-open.org/ebxml-msg/ebms/v3.0/ns/core/200704/defaultRole</eb:Role>
          </eb:To>
        </eb:PartyInfo>
        <eb:CollaborationInfo>
          <eb:Service>dbc-procid::urn:resources.digitalbusinesscouncil.com.au:dbc:einvoicing:ver1.0</eb:Service>
          <eb:Action>dbc-docid::urn:resources.digitalbusinesscouncil.com.au:dbc:invoicing:documents:core-invoice:xsd::core-invoice-1##urn:resources.digitalbusinesscouncil.com.au:dbc:einvoicing:process:einvoicing01:ver1.0</eb:Action>
          <eb:ConversationId></eb:ConversationId>
        </eb:CollaborationInfo>
        <eb:MessageProperties>
          <eb:Property name="originalSender" type="urn:oasis:names:tc:ebcore:partyid-type:iso6523:0151">corner1-abn</eb:Property>

          <eb:Property name="finalRecipient" type="urn:oasis:names:tc:ebcore:partyid-type:iso6523:0151">corner4-abn</eb:Property>
        </eb:MessageProperties>
        <eb:PayloadInfo>
          <eb:PartInfo href="cid:payload">
            <eb:PartProperties>
              <eb:Property name="MimeType">application/xml</eb:Property>
            </eb:PartProperties>
          </eb:PartInfo>
        </eb:PayloadInfo>
      </eb:UserMessage>
    </eb:Messaging>
  </soap:Header>
  <soap:Body/>
</soap:Envelope>

```
The cid:payload is the Content-ID of the additional mime attachment. This can be any document, the example includes is a UBL invoice as per the Digital Business Council standard.
