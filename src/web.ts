import { WebPlugin } from '@capacitor/core';

import type { FileUploadPlugin } from './definitions';

export class FileUploadWeb extends WebPlugin implements FileUploadPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
