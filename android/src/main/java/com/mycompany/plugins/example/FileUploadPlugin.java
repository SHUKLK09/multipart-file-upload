package com.mycompany.plugins.example;

import java.io.IOException;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;


@CapacitorPlugin(name = "FileUpload")
public class FileUploadPlugin extends Plugin {

    private FileUpload implementation = new FileUpload();

    @PluginMethod
    public void uploadFile(PluginCall call) {
        System.out.println(call.toString());
        try {
            JSObject response = implementation.uploadFile(call);
            System.out.println(response);
            call.resolve(response);
        } catch (IOException e) {
            System.out.println(e.toString());
            JSObject error = new JSObject();
            error.put("status", e.status);
            error.put("message", e.message);
            error.put("data", e.content);
            call.reject(error);
        } catch (Exception e) {
            call.reject(e.getClass().getSimpleName(), e);
        }
    }

}
