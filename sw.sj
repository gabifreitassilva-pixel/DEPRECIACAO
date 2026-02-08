// Nome do cache - mude a versão para forçar atualização no navegador do cliente
const CACHE_NAME = 'auditor-fiscal-v1.3';

// Lista de arquivos que o SW deve gerenciar e manter atualizados
const assets = [
  './',
  './index.html',
  './auto pecas.html',
  './bebidas alcolicas exceto cerveja e chope.html',
  './perfumaria e higiene pessoal.html',
  './Produtos alimenticios.html',
  './baselegal.html',
  './base reduzida.html',
  './materiais de contrucao e congeneres.html'
];

// Instalação: Salva os arquivos no cache
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      console.log('Cache instalado com sucesso');
      return cache.addAll(assets);
    })
  );
});

// Ativação: Limpa versões antigas do auditor para garantir que a lei atualizada prevaleça
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME)
            .map(key => caches.delete(key))
      );
    })
  );
});

// Estratégia de Busca: Tenta a rede primeiro para garantir dados fiscais novos, se falhar usa o cache
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );

});

