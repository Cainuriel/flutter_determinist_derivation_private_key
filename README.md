# Derivación Determinista Jerárquica de claves privadas en Flutter 

 Ejemplo de derivación con clave maestra para generar conjunto de claves hijas (pública y privada). 

 Así es como generan sus direcciones las más importantes billeteras del mercado, como por ejemplo __Metamask__.
 
 El metodo utilizado es la HD __(Hierarchical Deterministic) Derivation__, o derivación determinista jerárquica en español, a partir de una semila.

La semilla ("seed phrase" o "mnemonic") es una representación humana y amigable con la que se generarán todas las claves privadas y públicas.

La mayoría de las semillas están compuestas por 12 o 24 palabras elegidas de una lista de palabras predefinidas, la [bip-39-wordlist](https://www.blockplate.com/pages/bip-39-wordlist), que fue la propuesta [como standard para Bitcoin](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) y que a partir de ese momento se ha utilizado para el mismo fin en las principales EVM del mercado.

Las ventajas de ésta derivación es disponer con una sola clave madre múltiples pares de claves públicas y privadas a utilizar.
Otra ventaja es que si se comprometiese la clave privada de una de sus claves públicas, aún podría seguir usando las restantes al disponer de cada par su propia clave privada.

La aplicación utiliza la librería ``` web3dart ``` para la generación de un objeto wallet operativo para la conexión con dApps o ataque a blockchains. 
Cada par de claves se integra con su propio objeto wallet para que puedan utilizarse de forma independiente. 

## Instalación
Clonarse el proyecto y ejecutar ``` flutter pub get ```.
Comprobar el sistema con ``` flutter doctor  ```.
Debug con F5 durante el desarrollo si se tiene instalado un emulador android o IOS.
Para construir una aplicación en Android, iOS, Web... ``` flutter build android|ios|web ```.
ejecución: ``` flutter run android|ios|web ```.