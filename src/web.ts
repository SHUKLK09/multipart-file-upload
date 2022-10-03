import { WebPlugin } from '@capacitor/core';

import type { FileUploadPlugin } from './definitions';

export class FileUploadWeb extends WebPlugin implements FileUploadPlugin {
  async uploadFile(options: {
    url: string; headers: any; params: any; filePath: string;
    fileKey: string;
  }): Promise<{ output: { string: any; }; }> {
    console.log('FileUpload', options);
    throw new Error('Method not implemented.');
  }

  getPath(options: {contentURI: string}): Promise<{ string: any } > {
    console.log('getPath', options);

    throw new Error('Method not implemented.');
  }


}
