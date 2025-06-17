function waitForY(prompt)
    while (1)
        answer = strip(input(prompt, 's'));
        if strcmpi(answer, 'y')
            break
        end
    end

end