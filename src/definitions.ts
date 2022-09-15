export interface FileUploadPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
