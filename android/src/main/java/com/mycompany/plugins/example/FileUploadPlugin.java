package com.mycompany.plugins.example;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;


@CapacitorPlugin(name = "FileUpload")
public class FileUploadPlugin extends Plugin {

    private FileUpload implementation = new FileUpload();

    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod
    public void uploadFile(PluginCall call) {
        System.out.println(call.toString());
        try {
            JSObject response = implementation.uploadFile(call);
            System.out.println(response);
            call.resolve(response);
        } catch (Exception e) {
            System.out.println(e.toString());
            call.reject(e.getClass().getSimpleName(), e);
        }
    }
}
