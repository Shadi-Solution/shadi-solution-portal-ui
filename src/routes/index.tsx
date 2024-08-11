import { createFileRoute } from '@tanstack/react-router';

import App from '@/App/App';

export const Route = createFileRoute('/')({
  component: App,
});
