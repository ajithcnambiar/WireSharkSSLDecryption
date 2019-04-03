## How to use

The below script builds nginx image with SSL enabled and listens at port 444
```
bash -x build.sh
```

To test the server

```
curl -k 'https://localhost:444' 
```

ssl_ciphers is purposefully setup to weak so that SSL decryption with wireshark can be tested.

## Steps to test Wireshark HTTPS Decryption using RSA Key

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

5. Filter out the required packets:
    5.1 ssl.handshake.type == 1 // Filters out Client Hello
    5.2 Retrieve the TCP conversation history by Right click "Client Hello" and explore "Conversation Filter" -> TCP
    5.3 From the "Server Hello" packet check the Cipher Suite. It shouldn't be based on "Diffie Hellman". With this setup, I have noted it as "Cipher Suite: TLS_RSA_WITH_AES_256_GCM_SHA384 (0x009d)".
    5.4 Set the SSL decryption key to localhost.key
    ```
    Preferences -> Protocols -> RSA Key Edit
    IP Address : 127.0.0.1
    Port: 443
    Protocol: http
    Key File: /path/to/localhost.key
    ```

