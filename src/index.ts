import { registerPlugin } from '@capacitor/core';

import type { FileUploadPlugin } from './definitions';

const FileUpload = registerPlugin<FileUploadPlugin>('FileUpload', {
  web: () => import('./web').then(m => new m.FileUploadWeb()),
});

export * from './definitions';
export { FileUpload };
