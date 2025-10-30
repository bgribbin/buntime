import { serve } from 'bun';
import index from './index.html';
import { renderToReadableStream } from 'react-dom/server';
import Component from './components/ssr-react.tsx';

const server = serve({
  routes: {
    // Serve index.html for all unmatched routes.
    '/*': index,
    '/from-server': {
      async GET(req) {
        const stream = await renderToReadableStream(
          Component({ message: 'Hello from server!' })
        );
        return new Response(stream, {
          headers: {
            'Content-Type': 'text/html',
          },
        });
      },
    },

    '/api/hello': {
      async GET(req) {
        return Response.json({
          message: 'Hello, world!',
          method: 'GET',
        });
      },
      async PUT(req) {
        return Response.json({
          message: 'Hello, world!',
          method: 'PUT',
        });
      },
    },

    '/api/hello/:name': async (req) => {
      const name = req.params.name;
      return Response.json({
        message: `Hello, ${name}!`,
      });
    },
  },

  development: process.env.NODE_ENV !== 'production' && {
    // Enable browser hot reloading in development
    hmr: true,

    // Echo console logs from the browser to the server
    console: true,
  },
});

console.log(`🚀 Server running at ${server.url}`);
