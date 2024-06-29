import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kisiler_uygulamasi/data/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/ui/cubit/anasayfa_cubit.dart';
import 'package:kisiler_uygulamasi/ui/views/detay_sayfa.dart';
import 'package:kisiler_uygulamasi/ui/views/kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AnasayfaCubit>().kisileriYukle();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ? 
        TextField(
          decoration: const InputDecoration(hintText: "Ara"),
          onChanged: (aramaSonucu){
            context.read<AnasayfaCubit>().ara(aramaSonucu);
          },
        ) : 
        const Text("Kişiler"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
              });
              context.read<AnasayfaCubit>().kisileriYukle();
            }, 
            icon: const Icon(Icons.clear),
            ) : IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            }, 
            icon: const Icon(Icons.search),
            ),
        ],
        ),
      body: BlocBuilder<AnasayfaCubit,List<Kisiler>>(
        builder: (context, kisilerListesi) {
          if(kisilerListesi.isNotEmpty) {
            return ListView.builder(
              itemCount: kisilerListesi.length,
              itemBuilder: (context, index) {
                var kisi = kisilerListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetaySayfa(kisi: kisi)))
                    .then((value) {
                      context.read<AnasayfaCubit>().kisileriYukle();
                    });
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(kisi.kisi_ad, style: const TextStyle(fontSize: 20),),
                                Text(kisi.kisi_tel),
                              ],
                            ),
                          ),
                          IconButton(onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${kisi.kisi_ad} Silinsin mi?"),
                                action: SnackBarAction(
                                  label: "Evet", 
                                  onPressed: (){
                                    context.read<AnasayfaCubit>().sil(kisi.kisi_id);
                                  }
                                ),
                              ),
                            );
                          }, icon: Icon(Icons.clear, color: Colors.black54,),),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KayitSayfa()))
          .then((value) {
            context.read<AnasayfaCubit>().kisileriYukle();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}