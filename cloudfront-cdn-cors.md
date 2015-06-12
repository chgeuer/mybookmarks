# Enabling CORS on Amazon CloudFront with S3 as your Origin Server 

src: http://blog.errorception.com/2014/11/enabling-cors-on-amazon-cloudfront-with.html

## S3

- Log into your AWS S3 console, select your bucket, and select "Properties". S3 CORS configurations seem to apply at the level of the bucket, and not the file. I have no clue why. 
- Expand the "Permissions" pane, and click on "Add CORS configuration" or "Edit CORS configuration" depending on what you see. 
- You should already be provided with a default permission configuration XML. (Seriously, Amazon? 2014? XML?) If not, use the following XML to get started. http://docs.aws.amazon.com/AmazonS3/latest/dev/cors.html

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Authorization</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

In the course of this debugging exercise, I discovered the hard way that Amazon's XML parser cares about the <?xml ?> declaration, and the xmlns on the root node. If you omit these, Amazon will fail silently, showing you a happy looking green tick! (Can you imagine how hard it was to figure this out?)

Once you've saved the configuration, go get a coffee (or other preferred poison) while you wait for S3 to be one with your new configuration, and really internalise it's true meaning. (It takes a couple of minutes. Some sort of caching, I guess.) 

Test if everything's looking right. This really tripped me up. Turns out, for a really complicated reason, you can't simply hit a URL in your S3 bucket from within your browser and check the "Network" tab in your dev tools. That would be too easy. No, you need to ensure that you specify certain extra headers in your request. Now, it turns out that browsers send this with CORS requests anyway, so you are covered in the real-world, but it's crazy that the dev-experience for the common case isn't what you'd expect. You could use a tool like curl to specify the additional headers needed for a "correct" CORS request: 

```
$ curl -sI -H "Origin: example.com" -H "Access-Control-Request-Method: GET" https://s3.amazonaws.com/bucket/script.js

HTTP/1.1 200 OK
Date: Wed, 05 Nov 2014 13:37:20 GMT
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET
Access-Control-Max-Age: 3000
Vary: Origin, Access-Control-Request-Headers, Access-Control-Request-Method
Cache-Control: max-age=604800, public
```

You should see the "Access-Control-Allow-Origin: *" header, and the "Vary: Origin" header in the output. If you do, you're golden. 


## Configuring CloudFront

- Go to your CloudFront console, select your distribution and go to the "Behaviors" tab. 
- You should already have a "Default" behavior listed there. Select it and hit "Edit". 
- Under the "Whitelist Headers" section, navigate their clunky UI to add the "Origin" header to the whitelist. 
- Save, get another coffee, and wait for this to propagate through CloudFront's caches. This will take some time. 
- Test! Again, you will have to use the process above to make sure you are flipping the right switches within Amazon. That is, use curl (or some HTTP client), and ensure that you specify the extra headers. You should see the "Access-Control-" headers in the response. 

http://enable-cors.org/server.html
