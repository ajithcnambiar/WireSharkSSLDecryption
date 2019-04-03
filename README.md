# SSL Decryption with Wireshake using RSA Key

## Create HTTPS Nginx Server in the local

The below script builds nginx image with SSL enabled and listens at port 444
```
bash -x build.sh
```
* **Note:** Please provide details when prompted to create self signed certificate. Type enter character to take default. *localhost.key* and *localhost.crt* are created as part of self signed certificate and key generation. These artifacts are used to set up local https server.

To test the server

```
curl -k 'https://localhost:444' 
```

*ssl_ciphers* is purposefully set weak so that SSL decryption with wireshark can be tested.

## Steps to decrypt HTTPS using Wireshark

1. Capture network logs using tcpdump

```
sudo tcpdump -i any -s 10000 -w /tmp/tcpdump_logs
```

2. Test https traffic 

```
curl -k 'https://localhost:444'
```

3. Stop tcpdump capture.

4. Open /tmp/tcpdump_logs in wireshark

5. Filter out the required packets and set key to Wireshark.
    * *ssl.handshake.type == 1* to filter out *Client Hello*.
    * Retrieve the TCP conversation history by Right click *Client Hello* packet -> *Conversation Filter* -> *TCP*
    * From the *Server Hello* packet, check the *Cipher Suite*. It shouldn't be based on "Diffie Hellman". With this setup, I have noted *Cipher Suite* to be: *TLS_RSA_WITH_AES_256_GCM_SHA384 (0x009d)*
    * Set the SSL decryption key to *localhost.key*

    ```
    Preferences -> Protocols -> RSA Key Edit
    IP Address : 127.0.0.1
    Port: 443
    Protocol: http
    Key File: /path/to/localhost.key
    ```

6. Wireshark packets will be refreshed with decrypted information in the packets.

