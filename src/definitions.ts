export interface FileUploadPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  uploadFile(options: {url: string, headers?: any, params: any, filePath: string, fileKey?: string }): Promise<{output: {string:any}}>;

  // uploadFile(options: {url: string, headers: any, params: any, filePath: string, fileKey: string, fileData: any }): Promise<{ value: string }>;
}
