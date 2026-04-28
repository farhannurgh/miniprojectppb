package com.example.pelanggaranlalulintas;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class HasilFoto extends AppCompatActivity {
    private ImageView photo;
    static String uriResult;
    TextView tvJenisPelanggaran;
//    static double percentageResult;
    static String classNameResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.hasil_foto);

        // Inisialisasi ImageView
        photo = findViewById(R.id.foto);
        tvJenisPelanggaran = findViewById(R.id.jenis_pelanggaran);
        // Ambil Uri gambar dari Intent
        Intent intent = getIntent();

        if (uriResult != null) {
            Uri imageUri = Uri.parse(uriResult);
            // Tampilkan gambar di ImageView
            Bitmap bitmap = BitmapFactory.decodeFile(imageUri.getPath());
            photo.setImageURI(imageUri);
        }

        if (classNameResult != null) {
            if("Dilarang parkir".equals(classNameResult)){
                tvJenisPelanggaran.setText("Dilarang Parkir");
            }
            else if("no helmet".equals(classNameResult)){
                tvJenisPelanggaran.setText("Tidak Memakai Helm");
            }
            else if("main hp".equals(classNameResult)){
                tvJenisPelanggaran.setText("Menggunakan Handphone");
            }

        }
        else{
            tvJenisPelanggaran.setText("Tidak Melakukan Pelangaran");
        }

        // Tombol untuk melaporkan
        Button btnLaporkan = findViewById(R.id.button);
        btnLaporkan.setOnClickListener(v -> {
            // Pindahkan ke halaman FormLapor
            Intent formLaporIntent = new Intent(HasilFoto.this, FormLapor.class);
            startActivity(formLaporIntent);
        });
    }
    @Override
    protected void onDestroy(){
        super.onDestroy();
        resetResult();
    }
    public static void resetResult(){
        classNameResult = null;
        uriResult = null;
    }
    public static void getResult(String className){
        classNameResult = className;
//        percentageResult = confidence;
    }
    public static void getUri(String uri){
        uriResult = uri;
    }
}
