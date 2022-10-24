import os
import sys
from progress.bar import Bar
from PyPDF2 import PdfFileReader, PdfFileMerger

if __name__ == '__main__':
    if len(sys.argv) != 2:
        exit()

    if not os.path.exists(sys.argv[1]):
        exit()

    if not os.path.isdir(sys.argv[1]):
        exit()

    if not os.path.exists(os.path.join(sys.argv[1], 'output')):
        os.mkdir(os.path.join(sys.argv[1], 'output'))
    files = [f for f in os.listdir(sys.argv[1]) if os.path.isfile(os.path.join(sys.argv[1], f))]

    bar = Bar('Processing', max=len(files))

    for f in files:
        if os.path.splitext(f)[-1].lower() == '.pdf':
            file_in = open(os.path.join(sys.argv[1], f), 'rb')
            pdf_reader = PdfFileReader(file_in, strict=False)
            metadata = pdf_reader.getDocumentInfo()

            pdf_merger = PdfFileMerger(strict=False)
            pdf_merger.append(file_in)
            pdf_merger.addMetadata({
                '/Author': '',
                '/Title': f.replace(os.path.splitext(f)[-1], '')
            })
            file_out = open(os.path.join(os.path.join(sys.argv[1], 'output'), f), 'wb')
            pdf_merger.write(file_out)

            file_in.close()
            file_out.close()

            bar.next()

    bar.finish()
