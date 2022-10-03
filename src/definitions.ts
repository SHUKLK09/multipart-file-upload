export interface FileUploadPlugin {
  getPath(options: {contentURI: string}): Promise<{ string: any } >;
  uploadFile(options: {url: string, headers?: any, params: any, filePath: string, fileKey?: string }): Promise<{output: {string:any}}>;
}
