function make_html(confidences, paths, aps, settings)
% Makes the HTML file for submitting the models.
%
% [] = make_html(confidences, paths, aps, settings)
%   confidences     The confidences for each model
%   paths           The paths to the testing images
%   aps             The average precisions
%   settings        The settings

header = '<html lang="en"><head><meta charset="utf-8"><title>Image list prediction</title> <style type="text/css"> img {width:200px;}</style></head><body><h2>Nicole Ferreira Silverio, Cor Zuurmond</h2><h1>Settings</h1><table>';

fileID = fopen(sprintf('../%.0fim_%.0fvoc_%s_%s.html', settings.images_kmeans, settings.vocab_size, settings.color_scheme, settings.sift_type), 'w');
fprintf(fileID, header);

if settings.sift_type == 'dense'
    fprintf(fileID, '<tr><th>SIFT step size</th><td>10 px</td></tr>');
else
    fprintf(fileID, '<tr><th>SIFT step size</th><td>N/A</td></tr>');
end
fprintf(fileID, '<tr><th>SIFT block sizes</th><td>default </td></tr>');
fprintf(fileID, '<tr><th>SIFT method</th><td>%s-SIFT</td></tr>', settings.sift_type);
fprintf(fileID, '<tr><th>Vocabulary size</th><td>%.0f words</td></tr>', settings.vocab_size);
fprintf(fileID, '<tr><th>Vocabulary fraction</th><td>%.3f</td></tr>', (settings.images_train/settings.vocab_size));
fprintf(fileID, '<tr><th>SVM training data</th><td>%.0f positive, %.0f negative per class</td></tr>', settings.images_train, (3*settings.images_train));
fprintf(fileID, '<tr><th>SVM kernel type</th><td>N/A</td></tr></table>');
fprintf(fileID,  '<h1>Prediction lists (MAP: %.3f)</h1>', mean(aps));

inbetween = '<h3><font color="red">Following are the ranking lists for the four categories. Please fill in your lists.</font></h3><h3><font color="red">The length of each column should be 200 (containing all test images).</font></h3><table><thead><tr>';
fprintf(fileID, inbetween);

fprintf(fileID, '<th>Airplanes (AP: %.3f)</th><th>Cars (AP: %.3f)</th><th>Faces (AP: %.3f)</th><th>Motorbikes (AP: %.3f)</th></tr></thead><tbody>', aps);

ordered = [];
for conf=confidences
    ordered_ = sortrows([conf, paths.'], 'descend');
    ordered = [ordered ordered_(:, 2)];
end
for i=1:numel(paths)
    p1 = char(ordered(i, 1));
    p2 = char(ordered(i, 2));
    p3 = char(ordered(i, 3));
    p4 = char(ordered(i, 4));
    fprintf(fileID, '<tr><td><img src="%s" /></td><td><img src="%s" /></td><td><img src="%s" /></td><td><img src="%s"/></td></tr>', p1(68:end), p2(68:end), p3(68:end), p4(68:end));
end

final = '</tbody></table></body></html>';
fprintf(fileID, final);

fclose(fileID);
end