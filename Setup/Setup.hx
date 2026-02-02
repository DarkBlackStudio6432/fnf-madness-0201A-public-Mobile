import sys.io.Process;
import sys.io.File;

class Setup {
    static public function main() {
        trace("📦 Iniciando setup do Madness Engine 0.7.3 para Android...\n");

        // Lista de Haxelib necessárias
        var haxelibs = [
            "flixel",
            "flixel-ui",
            "flixel-addons",
            "flxanimate",
            "tjson",
            "hxcpp",
            "hxvlc",
            "SScript:8.1.6",
            "linc_luajit"
        ];

        // Libs Git específicas
        var gitLibs = [
            {name: "hxdiscord_rpc", url: "https://github.com/MAJigsaw77/hxdiscord_rpc"},
            {name: "flxanimate", url: "https://github.com/ShadowMario/flxanimate", ref: "dev"},
            {name: "linc_luajit", url: "https://github.com/superpowers04/linc_luajit"}
        ];

        // Instala as Haxelibs normais
        for (lib in haxelibs) {
            var parts = lib.split(":");
            var name = parts[0];
            var version = if (parts.length > 1) parts[1] else null;
            var cmd = if (version != null) "haxelib install " + name + " " + version else "haxelib install " + name;
            run(cmd);
        }

        // Instala as Haxelibs Git
        for (lib in gitLibs) {
            var ref = if (Reflect.hasField(lib, "ref")) lib.ref else "master";
            run("haxelib git " + lib.name + " " + lib.url + " " + ref);
        }

        trace("\n📱 Configurando ambiente Android...");
        run("yes | haxelib run lime setup android");

        trace("\n✅ Setup concluído! Você já pode rodar:\n lime test android\n lime build android -final");
    }

    static function run(cmd:String) {
        trace("▶ " + cmd);
        try {
            var p = new Process(cmd);
            var output = p.stdout.readAll();
            trace(output);
            p.close();
        } catch(e:Dynamic) {
            trace("⚠ Erro ao executar: " + cmd);
            trace(e);
        }
    }
}
