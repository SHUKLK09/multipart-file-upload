import { WebPlugin } from '@capacitor/core';

import type { FileUploadPlugin } from './definitions';

export class FileUploadWeb extends WebPlugin implements FileUploadPlugin {
  async uploadFile(options: {
    url: string; headers: any; params: any; filePath: string;
    fileKey: string; fileData: any;
  }): Promise<{ output: { string: any; }; }> {
    console.log('FileUpload', options);
    throw new Error('Method not implemented.');
  }
  
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
  



}
