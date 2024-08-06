package com.raylibtemplate;

import android.os.Bundle;

public class NativeLoader extends android.app.NativeActivity {
    static {
        System.loadLibrary("main");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
}
