package com.mycompany.plugins.example;

import com.getcapacitor.JSObject;
import com.getcapacitor.PluginCall;

import org.json.*;

import android.os.Environment;
import android.util.Log;
import android.webkit.MimeTypeMap;


import java.io.File;
import java.io.IOException;
import java.net.*;

import java.util.*;
import com.getcapacitor.JSArray;

import com.google.api.client.http.ByteArrayContent;
import com.google.api.client.http.FileContent;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpHeaders;
import com.google.api.client.http.HttpMediaType;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestFactory;
import com.google.api.client.http.HttpResponse;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.MultipartContent;
import com.google.api.client.http.javanet.NetHttpTransport;


public class FileUpload {

    public JSObject uploadFile(PluginCall call) throws IOException, URISyntaxException, JSONException {
        String urlString = call.getString("url");
        String filePath = call.getString("filePath");
        String fileKey = call.getString("fileKey", "file");
        JSObject headers = call.getObject("headers", new JSObject());
        JSObject params = call.getObject("params");
    
        Map<String, String> parameters = new LinkedHashMap<>();
        for (Iterator<String> it = params.keys(); it.hasNext(); ) {
            String key = it.next();
            parameters.put(key, params.getString(key));
        }

        String mimeType = getMimeType(filePath);
//        String newFilePath = filePath.replace("file://", "");
        FileContent fileContent;
        try {
            String newFilePath = filePath.replace("file:", "");
            fileContent = new FileContent(mimeType, new File(newFilePath));
        } catch (Exception e) {
            throw e;
        }

        // Add parameters
        MultipartContent content = new MultipartContent().setMediaType(
                new HttpMediaType("multipart/form-data")
                        .setParameter("boundary", "__END_OF_PART__"));
        for (String name : parameters.keySet()) {
            MultipartContent.Part part = new MultipartContent.Part(
                    new ByteArrayContent(null, parameters.get(name).getBytes()));
            part.setHeaders(new HttpHeaders().set(
                    "Content-Disposition", String.format("form-data; name=\"%s\"", name)));
            content.addPart(part);
        }
       
        MultipartContent.Part part = new MultipartContent.Part(fileContent);
        part.setHeaders(new HttpHeaders().set(
                "Content-Disposition",
                String.format("form-data; name=\"%s\"; filename=\"%s\"", fileKey, fileContent.getFile().getName())));
        content.addPart(part);

        HttpTransport netHttpTransport = new NetHttpTransport();
        HttpRequestFactory requestFactory = netHttpTransport.createRequestFactory();
        HttpRequest request =
        requestFactory.buildPostRequest( new GenericUrl(urlString), content);
        HttpResponse response = request.execute();


        return handleResponse(response);
    }

    public String getMimeType(String url) {
        String type = null;
        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
        if (extension != null) {
            type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        }
        return type;
    }

    private JSObject handleResponse(HttpResponse response){
        var output = new JSObject();
        output.put("status", response.getStatusCode());
        output.put("headers", response.getHeaders());
        try {
            String contentType = response.getContentType();
            var json =  response.parseAsString();
            output.put("data", response.parseAsString());
        } catch (IOException e) {
            e.printStackTrace();
        }

//        String result = new String(response.getContent(), "UTF-8");
//
//        if (result != null){
//            output.put("data", parseJSON(result));
//        }

        return output;
    }

    private  Object parseJSON(String input) throws JSONException {
        JSONObject json = new JSONObject();
        try {
            if ("null".equals(input.trim())) {
                return JSONObject.NULL;
            } else if ("true".equals(input.trim())) {
                return new JSONObject().put("flag", "true");
            } else if ("false".equals(input.trim())) {
                return new JSONObject().put("flag", "false");
            } else {
                try {
                    return new JSObject(input);
                } catch (JSONException e) {
                    return new JSArray(input);
                }
            }
        } catch (JSONException e) {
            return new JSArray(input);
        }
    }

}
