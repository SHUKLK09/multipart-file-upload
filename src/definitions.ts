export interface FileUploadPlugin {
  uploadFile(options: {url: string, headers?: any, params: any, filePath: string, fileKey?: string }): Promise<{output: any }>;
}
