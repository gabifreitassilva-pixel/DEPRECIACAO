// 1. Mude a versão (v1.5) sempre que alterar qualquer código nos seus arquivos HTML ou leis
const CACHE_NAME = 'auditor-fiscal-v1.6';

// 2. Lista completa e exata de arquivos que devem funcionar offline
const assets = [
  './',
  './index.html',
  './histórico.html',
  './extrato simples.html',
  './Retificacoes.html',
  './auto pecas.html',
  './base reduzida.html',
  './baselegal.html',
  './bebidas alcolicas exceto cerveja e chope.html',
  './Brinquedos e artigos de esporte.html',
  './cerveja chopes refrigerante agua e outras bebidas.html',
  './cigarros e outros produtos derivados do fumo.html',
  './cimentos.html',
  './combustivel e lubrificantes.html',
  './Eletronicos e eletrodomesticosl.html',
  './energia eletrica.html',
  './ferramenta.html',
  './lampadas reatores e starters.html',
  './materiais de contrucao e congeneres.html',
  './materiais de contrucao e congeneres vidros e metais.html',
  './Materiais eletricos.html',
  './perfumaria e higiene pessoal.html',
  './pis e cofins.html',
  './Produtos alimenticios.html'
];

// Instalação: Salva todos os arquivos na memória do navegador
self.addEventListener('install', event => {
  // skipWaiting faz com que a nova versão assuma o controle imediatamente
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      console.log('SW: Mapeando arquivos para funcionamento offline');
      return cache.addAll(assets);
    })
  );
});

// Ativação: Remove caches antigos e garante que a nova lei tributária prevaleça
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME)
            .map(key => caches.delete(key))
      );
    })
  );
  // Reivindica o controle das abas abertas imediatamente
  self.clients.claim();
});

// Estratégia de Busca: Network First (Tenta buscar no GitHub primeiro)
// Isso garante que, se você mudar um NCM no GitHub, o cliente receba a atualização na hora se tiver internet.
// Se estiver sem internet, ele carrega o que está no cache.
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request).catch(() => {
      return caches.match(event.request);
    })
  );
});

